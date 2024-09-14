import {Link} from "react-router-dom";

const Navbar = () => {
    return (
        <div className="h-16 w-full flex flex-col items-center sm:flex-row sm:justify-between bg-slate-500">
            <div className="h-full px-4 flex items-center sm:ml-8"><a className="text-white text-lg">Logo</a></div>
            <div className="h-full flex items-center sm:mr-8">
                <div>
                    <Link to="/login" className="text-white text-lg px-1">Login</Link>
                </div>
                <div>
                    <Link to="/register" className="text-white text-lg px-1">Register</Link>
                </div>             
            </div>
        </div>
    )
}
export default Navbar;