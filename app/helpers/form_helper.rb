module FormHelper
  def input_class
    "placeholder:text-slate-400 text-slate-700 border-2 py-2.5 px-4 border-slate-200 bg-slate-50 rounded-xl w-full text-lg sm:text-xl focus:border-blue-400 focus:ring-blue-400"
  end

  def button_class
    "bg-gradient-to-r bg-slate-500 to-blue-700 text-white rounded-xl py-1.5 px-4 text-center text-lg sm:text-xl font-semibold w-full hover:bg-gradient-to-tr"
  end

  def sm_button_class
    "bg-gradient-to-r from-blue-500 to-yellow-500 text-white rounded-xl py-2.5 px-4 text-center text-lg sm:text-xl font-semibold w-full hover:bg-gradient-to-tr"
  end

end