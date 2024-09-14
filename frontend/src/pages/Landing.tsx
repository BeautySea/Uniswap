import { ReactElement } from "react";
import LandingLayout from "../components/layouts/LandingLayout";
import "./Landing.css";
const Landing = ():ReactElement => {
    return (
        <LandingLayout>
            <div className="custom-hight bg-gray-200 flex justify-center items-center ">
                <div className="w-full h-20 px-2 sm:px-8 md:h-36 bg-gray-600 flex justify-center items-center">
                    <h1 className="text-white text-md sm:text-lg md:text-[40px]">Landing Page</h1>
                </div>
            </div>
        </LandingLayout>
    ); 
}
export default Landing;