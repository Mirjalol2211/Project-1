const API = "http://127.0.0.1:8000"

let map = L.map('map').setView([41.2995, 69.2401], 12)

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
}).addTo(map)

let markers = []


function clearMarkers(){

    markers.forEach(m => map.removeLayer(m))
    markers = []
}


async function loadApartments(){

    clearMarkers()

    let res = await fetch(API + "/apartments")
    let data = await res.json()

    let minPrice = document.getElementById("minPrice").value
    let maxPrice = document.getElementById("maxPrice").value
    let rooms = document.getElementById("rooms").value
    let type = document.getElementById("type").value

    data.forEach(a=>{

        if(minPrice && a.price < minPrice) return
        if(maxPrice && a.price > maxPrice) return
        if(rooms && a.rooms != rooms) return
        if(type && a.type != type) return

        let marker = L.marker([a.lat,a.lon]).addTo(map)

        marker.bindPopup(`
        <b>${a.price}$</b><br>
        Area: ${a.area} m²<br>
        Rooms: ${a.rooms}<br>
        District: ${a.district}<br>
        ${a.price_per_m2}$ / m²
        `)

        markers.push(marker)

    })

}

async function loadStats(){

    let res = await fetch(API + "/districts/stats")
    let data = await res.json()

    let html = ""

    data.forEach(d=>{

        html += `
        <div>
        <b>${d.district}</b><br>
        avg price: ${d.avg_price}$<br>
        avg m2: ${d.avg_price_m2}$<br>
        listings: ${d.count}
        </div><br>
        `
    })

    document.getElementById("stats").innerHTML = html

}

loadApartments()
loadStats()
