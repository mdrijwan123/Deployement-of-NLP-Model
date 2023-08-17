from flask import Flask,render_template,url_for,request
import pandas as pd 
import numpy as np
from nltk.stem.porter import PorterStemmer
import re
import string
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
import pickle

## Definitions to remove any patterns or punctuations from given statement
def remove_pattern(input_txt,pattern):
    r = re.findall(pattern,input_txt)
    for i in r:
        input_txt = re.sub(i,'',input_txt)
    return input_txt
def count_punct(text):
    count = sum([1 for char in text if char in string.punctuation])
    return round(count/(len(text) - text.count(" ")),3)*100


app = Flask(__name__)


model_filename = "finalized_model.sav"
cv_filename = "finalized_count_vectoriser.sav"
loaded_model = pickle.load(open(model_filename, 'rb'))
loaded_cv = pickle.load(open(cv_filename, 'rb'))

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/predict',methods=['POST'])
def predict():
    if request.method == 'POST':
        # We get the message from a form
        message = request.form['message']
        data = [message]
        
        # we vectorise the input after treating with removing patterns
        tidy_tweet = pd.Series(np.vectorize(remove_pattern)(data,"@[\w]*"))
        
        # split the string inputs
        tokenized_tweet = tidy_tweet.apply(lambda x: x.split())
        
        # stem the inputs so that it create unbiased opinion for given model.
        stemmer = PorterStemmer()
        tokenized_tweet = tokenized_tweet.apply(lambda x: [stemmer.stem(i) for i in x]) 
        for i in range(len(tokenized_tweet)):
            tokenized_tweet[i] = ' '.join(tokenized_tweet[i])
        
        # Save the tokenized tweet, body length and punctations if they have
        tokenized_tidy_tweet = tokenized_tweet
        body_len = pd.Series(data).apply(lambda x:len(x) - x.count(" "))
        punct = pd.Series(data).apply(lambda x:count_punct(x))
        
        # transform the tokentised tweet to get a vectorized format
        X_result = loaded_cv.transform(tokenized_tidy_tweet)
        
        # concat all the 3 values to form a one input
        input = pd.concat([body_len,punct,pd.DataFrame(X_result.toarray())],axis = 1).values
        
        # predicting the results
        my_prediction = loaded_model.predict(input)
        
    # giving the results back to the html response
    return render_template('result.html',prediction = my_prediction)


if __name__ == '__main__':
    app.run(host='0.0.0.0',port=4000)
