package com.example.embeddedflutter

data class ImageItem(
    val id: Int,
    val title: String,
    val category: String,
    val description: String,
    val likes: Int,
    val views: Int
) {
    val thumbUrl get() = "https://picsum.photos/id/$id/400/400"
    val fullUrl  get() = "https://picsum.photos/id/$id/800/1000"
}

object ImageRepository {
    val items = listOf(
        ImageItem(10,  "Forest Path",      "Nature",       "A winding trail disappears into the heart of an ancient forest, where sunlight filters gently through the canopy.", 1240, 8930),
        ImageItem(29,  "Mountain Lake",    "Landscape",    "Crystal-clear alpine waters mirror the jagged peaks above in perfect symmetry.", 3410, 21500),
        ImageItem(37,  "City Rooftops",    "Architecture", "A maze of terracotta rooftops stretches toward the horizon under a warm golden sky.", 870,  6200),
        ImageItem(65,  "Ocean Horizon",    "Travel",       "Where the endless blue ocean meets the sky, a sense of infinite possibility opens up.", 5600, 43000),
        ImageItem(96,  "Urban Geometry",   "Architecture", "Bold lines and angular shadows define the facade of a modernist building downtown.", 2100, 15800),
        ImageItem(102, "Morning Coffee",   "Lifestyle",    "Steam rises from a freshly brewed cup on a quiet morning table, promising a gentle start.", 4830, 32100),
        ImageItem(110, "Sandy Shore",      "Travel",       "Fine white sand meets turquoise water in a secluded cove far from the tourist trail.", 7200, 58000),
        ImageItem(119, "Misty Peaks",      "Landscape",    "Dawn mist clings to the valley between sharp ridgelines, softening the scene like watercolour.", 3950, 27400),
        ImageItem(167, "Autumn Leaves",    "Nature",       "A burst of red and amber foliage signals the arrival of autumn in this quiet park.", 2760, 19600),
        ImageItem(180, "Desert Dunes",     "Travel",       "Sculpted by the wind, enormous sand dunes cast dramatic shadows across the desert floor.", 6100, 47200),
    )

    fun find(id: Int) = items.first { it.id == id }
}
