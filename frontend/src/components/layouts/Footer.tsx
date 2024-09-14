const Footer = () => {
    return (
        <footer className="flex flex-col sm:flex-row sm:justify-between items-center h-20 bg-gray-500">
            <div className="flex items-center sm:ml-6">
                <a className="text-white text-lg">@copyright</a>
            </div>
            <div className="flex items-center sm:mr-6">
                <a className="text-white text-lg">Contact</a>
            </div>
        </footer>
    )
}
export default Footer;