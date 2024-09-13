import { ReactElement } from "react";

const Footer = () => {
    return (
        <footer className="flex flex-column justify-end sm:flex-row sm:justify-between items-center h-20 bg-grey-500">
            <div>
                <a className="text-white text-lg">@copyright</a>
            </div>
            <div>
                <a className="text-white text-lg">Contact</a>
            </div>
        </footer>
    )
}
export default Footer;