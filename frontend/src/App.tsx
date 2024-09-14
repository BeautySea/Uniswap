import {BrowserRouter as Router, Routes, Route} from 'react-router-dom';
import './App.css';
import Landing from './pages/Landing';
// const PrivateRoute = ({element}:{element:ReactElement}) => (
//   const token = localStorage.getItem('authToken');
//   return token? element: <Navigate to="login"/>
// )
// const AuthenticatedRoute = ({element}:{element:ReactElement})=> (
//   // get the authToken from the localstorage
//   const token = localStorage.getItem('authToken');
//   return token? <Navigate to="/dashboard"/>: element;
// )  

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Landing/>} />
      </Routes>
    </Router>
  );
}
export default App;
