import requests
from bs4 import BeautifulSoup
import time
import csv

# Top 150 in Cook County, 2021 - 2024
species_list = ["American Robin", "House Sparrow", "Northern Cardinal", "Canada Goose", 
"Mallard", "Red-winged Blackbird", "Ring-billed Gull", "European Starling", 
"American Goldfinch", "Downy Woodpecker", "Black-capped Chickadee", 
"Mourning Dove", "Common Grackle", "Song Sparrow", "House Finch", 
"Blue Jay", "American Crow", "Rock Pigeon", "Dark-eyed Junco", 
"Red-bellied Woodpecker", "Northern Flicker", "Chimney Swift", 
"American Herring Gull", "Double-crested Cormorant", "Great Blue Heron", 
"Brown-headed Cowbird", "Barn Swallow", "White-breasted Nuthatch", 
"Gray Catbird", "White-throated Sparrow", "Yellow-rumped Warbler", 
"Killdeer", "Red-tailed Hawk", "Tree Swallow", "Common Yellowthroat", 
"Northern House Wren", "Baltimore Oriole", "Blue-gray Gnatcatcher", 
"Wood Duck", "Hairy Woodpecker", "Palm Warbler", "Warbling Vireo", 
"Red-breasted Merganser", "Ruby-crowned Kinglet", "Yellow Warbler", 
"Cooper's Hawk", "American Redstart", "White-crowned Sparrow", 
"Cedar Waxwing", "Swainson's Thrush", "Northern Rough-winged Swallow", 
"Golden-crowned Kinglet", "American Tree Sparrow", "Eastern Wood-Pewee", 
"Eastern Kingbird", "Swamp Sparrow", "Ruby-throated Hummingbird", 
"Indigo Bunting", "Magnolia Warbler", "Red-eyed Vireo", "Great Egret", 
"Spotted Sandpiper", "American Kestrel", "Nashville Warbler", 
"Black-and-white Warbler", "Black-crowned Night Heron", "Hermit Thrush", 
"Belted Kingfisher", "Green Heron", "Eastern Phoebe", "Common Goldeneye", 
"Brown Creeper", "Chipping Sparrow", "Tennessee Warbler", "Eastern Towhee", 
"Purple Martin", "Rose-breasted Grosbeak", "Least Flycatcher", 
"Turkey Vulture", "Northern Waterthrush", "Savannah Sparrow", 
"Field Sparrow", "Great Crested Flycatcher", "Brown Thrasher", 
"American Coot", "Red-breasted Nuthatch", "Black-throated Green Warbler", 
"Bank Swallow", "Chestnut-sided Warbler", "Blackpoll Warbler", 
"Wilson's Warbler", "Blue-winged Teal", "Red-headed Woodpecker", 
"Common Merganser", "Fox Sparrow", "Lincoln's Sparrow", "Bay-breasted Warbler", 
"Ovenbird", "Bufflehead", "Bald Eagle", "Yellow-bellied Sapsucker", 
"Hooded Merganser", "Eastern Bluebird", "Blackburnian Warbler", 
"Pied-billed Grebe", "Cape May Warbler", "Peregrine Falcon", 
"Greater Scaup", "Veery", "Piping Plover", "Sandhill Crane", 
"Horned Grebe", "Eastern Meadowlark", "Scarlet Tanager", "Northern Parula", 
"Orchard Oriole", "Winter Wren", "Solitary Sandpiper", "Northern Shoveler", 
"Redhead", "Canada Warbler", "Orange-crowned Warbler", "Lesser Scaup", 
"Wood Thrush", "Black-throated Blue Warbler", "Cliff Swallow", 
"Gray-cheeked Thrush", "Least Sandpiper", "Tufted Titmouse", 
"Common Nighthawk", "Willow Flycatcher", "Mute Swan", "Green-winged Teal", 
"Lesser Yellowlegs", "Gadwall", "Semipalmated Plover", "Sanderling", 
"Semipalmated Sandpiper", "Ring-necked Duck", "Marsh Wren", "Mourning Warbler", 
"Blue-headed Vireo", "Great Horned Owl", "Northern Harrier", 
"Purple Finch", "Pine Siskin", "Pileated Woodpecker", "Philadelphia Vireo", 
"Dickcissel", "Yellow-throated Vireo"
]

# All images from All About Birds
base_url = "https://www.allaboutbirds.org/guide/"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                  "AppleWebKit/537.36 (KHTML, like Gecko) "
                  "Chrome/122.0.0.0 Safari/537.36",
    "Accept-Language": "en-US,en;q=0.9",
    "Referer": "https://www.google.com"
}

results = []

# URLs do not contain spaces or apostrophes in species names
for species in species_list:
    cleaned_species_name = species.replace("'", "").replace(" ", "_")
    url = f"{base_url}{cleaned_species_name}/photo-gallery" # Exact page to scrape

    try:
        response = requests.get(url, headers = headers, timeout = 10)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        # Extract main image from site
        image_tag = soup.find("meta", property = "og:image")
        image_url = image_tag["content"] if image_tag else "Not found"

        # Sanity checker
        print(f"{species} -> {image_url}")
        results.append((species, image_url))

    except Exception as e:
        print(f"Failed for {species}: {e}")

    time.sleep(1)

# Save links out to cleaned data folder
with open("data/cleaned_data/scraped_images.csv", "w", newline = "", encoding = "utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["Common Name", "Image URL"])
    writer.writerows(results)
