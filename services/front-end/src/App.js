import './App.scss';
import { useEffect, useState } from 'react'
import { encode } from "base-64";

const fetchAllUser = async (setUsers) => {

  const usersRaw = await fetch(
    `${process.env.REACT_APP_API_ENDPOINT}/users`,
    {
      method: 'get',
      headers: new Headers({
        'Authorization': `Basic ${encode(process.env.REACT_APP_API_BASIC_USER + ":" + process.env.REACT_APP_API_BASIC_PASSWORD)}`,
        'Content-Type': 'application/json'
      }),
    },
  );
  const users = await usersRaw.json();
  if (users.length > 0) {
    setUsers(users);
  }
}

function App() {

  const [users, setUsers] = useState([]);
  useEffect(() => {
    (async () => {
      await fetchAllUser(setUsers);
    })()
  }, []);
  return (
    <div className="App">
      <div className="head">
        <h1>UsersPage</h1>
      </div>
      <div></div>
      <div>
        <table id="users_table">
          <thead>
            <tr>
              <th>User Id</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Cell Phone</th>
              <th>age</th>
            </tr>
          </thead>
          <tbody>
            {
              users.length <= 0
              && <tr>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
                <td>-</td>
              </tr>
            }
            {
              users.length > 0
              && users.map((user) => {
                return (
                  <tr key={`${user.id}_userUnique`}>
                    <td>{user.id}</td>
                    <td>{user.first_name}</td>
                    <td>{user.last_name}</td>
                    <td>{user.cell_phone}</td>
                    <td>{user.age}</td>
                  </tr>
                )
              })
            }
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default App;
