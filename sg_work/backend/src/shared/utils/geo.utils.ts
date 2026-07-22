export function pointToGeoJSON(lat: number, lng: number): any {
  return {
    type: 'Point',
    coordinates: [lng, lat], // PostgreSQL uses (longitude, latitude)
  };
}

export function geoJSONToPoint(geo: any): { lat: number; lng: number } | null {
  if (!geo || geo.type !== 'Point') return null;
  const [lng, lat] = geo.coordinates;
  return { lat, lng };
}