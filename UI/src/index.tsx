import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { Provider } from 'react-redux';
import { RootStore } from './Stores/store';

ReactDOM.render(
  <React.StrictMode>
	  <Provider store={RootStore}>
  		<App />
	  </Provider>
  </React.StrictMode>,
  document.getElementById('root')
);
