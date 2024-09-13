import { ReactElement, ReactNode} from "react";
import Navbar from "./Navbar";
import Footer from "./Footer";
const LandingLayout = ({children}:{children:ReactNode}):ReactElement=> {
    return (
        <>
            <Navbar/>
            {children}
            <Footer/>
        </>
    )
}
export default LandingLayout;