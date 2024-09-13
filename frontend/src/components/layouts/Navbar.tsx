import { ReactElement } from "react";
import {Link} from "react-router-dom";

const Navbar = () => {
    return (
        <div className="h-16 w-full flex flex-column justify-end sm:flex-row sm:justify-between items-center bg-slate-500">
            <div className="h-full px-4"><a className="text-white text-lg">Logo</a></div>
            <div className="h-full me-8">
                <Link to="/login" className="text-white text-lg">Login</Link>
                <Link to="/register" className="text-white text-lg">Register</Link>
            </div>
        </div>
    )
}
export default Navbar;