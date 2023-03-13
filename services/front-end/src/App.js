import './App.scss';
import { useEffect, useState } from 'react'
import { encode } from "base-64";



function App() {

  const [users, setUsers] = useState([]);
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [cell, setCell] = useState('');
  const [age, setAge] = useState('');

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

  const removeAllFields = () => {
    setFirstName('');
    setLastName('');
    setCell('');
    setAge('');
  }

  const handleCreateUser = async () => {

    const body = {
      first_name: firstName,
      last_name: lastName,
      cell_phone: cell,
      age: age,
    }

    removeAllFields();

    await fetch(
      `${process.env.REACT_APP_API_ENDPOINT}/users`,
      {
        method: 'put',
        headers: new Headers({
          'Authorization': `Basic ${encode(process.env.REACT_APP_API_BASIC_USER + ":" + process.env.REACT_APP_API_BASIC_PASSWORD)}`,
          'Content-Type': 'application/json'
        }),
        body: JSON.stringify(body)
      },
    );
    await fetchAllUser(setUsers);
  }

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
      <div
        className='create_user'
      >
        <form action="/action_page.php">
          <label for="fname">First Name</label>
          <input
            type="text"
            placeholder="Your name.."
            value={firstName}
            onChange={(event) => {
              setFirstName(event.target.value)
            }}
          />

          <label for="lname">Last Name</label>
          <input
            type="text"
            placeholder="Your last name.."
            value={lastName}
            onChange={(event) => {
              setLastName(event.target.value)
            }}
          />

          <label for="lname">Cell phone</label>
          <input
            type="text"
            placeholder="Your Cell phone.."
            value={cell}
            onChange={(event) => {
              setCell(event.target.value)
            }}
          />


          <label for="lname">Age</label>
          <input
            type="text"
            placeholder="Your Age.."
            value={age}
            onChange={(event) => {
              setAge(event.target.value)
            }}
          />


          {
            (
              age
              && cell
              && firstName
              && lastName
            ) && <input
              type="button"
              value="Submit"
              onClick={async () => {
                await handleCreateUser();
              }}
            />
          }


        </form>
        <br />
        <br />
        <br />
      </div>
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
