let count = 0;

module.exports ={
    getCounter : function () {
        count++
        console.log(count)
        return count
    },

    setCounter : function (number) {
        console.log("Before: " + count )
        count = number;
        console.log("After: " + count)
    }
}