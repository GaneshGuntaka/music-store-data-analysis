1. Customer Table
Primary Key (PK): customer_id
Attributes: first_name, last_name, company, address, city, state, country, postal_code, phone, fax, email, support_rep_id.
Foreign Key (FK): support_rep_id → employee.employee_id
(Each customer may have a support representative assigned.)

Relationships:
One-to-Many: Customer → Invoice (a customer can have many invoices).
Many-to-One: Customer → Employee (many customers can be assigned to one employee).

2. Employee Table
PK: employee_id
Attributes: last_name, first_name, title, reports_to, levels, birthdate, hire_date, address, city, state, country, postal_code, phone, fax, email.
FK: reports_to → employee.employee_id (self-referencing hierarchy).

Relationships:
One-to-Many (self): An employee can manage other employees.
One-to-Many: Employee → Customer (employees support many customers).

3. Invoice Table
PK: invoice_id
Attributes: customer_id, invoice_date, billing_address, billing_city, billing_state, billing_country, billing_postal_code, total.
FK: customer_id → customer.customer_id

Relationships:
Many-to-One: Invoice → Customer (an invoice belongs to a single customer).
One-to-Many: Invoice → InvoiceLine (an invoice contains multiple lines/tracks).

4. InvoiceLine Table
PK: invoice_line_id
Attributes: invoice_id, track_id, unit_price, quantity.

FKs:
invoice_id → invoice.invoice_id
track_id → track.track_id

Relationships:
Many-to-One: InvoiceLine → Invoice (line belongs to one invoice).
Many-to-One: InvoiceLine → Track (line references one track).

5. Track Table
PK: track_id
Attributes: name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price.

FKs:
album_id → album.album_id
media_type_id → mediatype.media_type_id
genre_id → genre.genre_id

Relationships:
Many-to-One: Track → Album, Track → Mediatype, Track → Genre.
One-to-Many: Track → InvoiceLine (a track can appear on many invoices).
Many-to-Many: Track ↔ Playlist (via PlaylistTrack).

6. Album Table
PK: album_id
Attributes: title, artist_id.
FK: artist_id → artist.artist_id
Relationships:
Many-to-One: Album → Artist.
One-to-Many: Album → Track (an album contains multiple tracks).

7. Artist Table
PK: artist_id
Attributes: name.
Relationships:
One-to-Many: Artist → Album (an artist can have multiple albums).

8. MediaType Table
PK: media_type_id
Attributes: name.
Relationships:
One-to-Many: Mediatype → Track (tracks are available in various media types).

9. Genre Table
PK: genre_id
Attributes: name.
Relationships:
One-to-Many: Genre → Track.

10. Playlist Table
PK: playlist_id
Attributes: name.
Relationships:
Many-to-Many: Playlist ↔ Track (via PlaylistTrack).

11. PlaylistTrack Table
Composite PK: (playlist_id, track_id)

FKs:
playlist_id → playlist.playlist_id
track_id → track.track_id

Relationships:
Implements many-to-many relationship between Playlist and Track.


## Relationships Overview

One-to-Many:
Customer → Invoice
Invoice → InvoiceLine
Employee → Customer
Employee (self) → Employee (reports_to hierarchy)
Artist → Album
Album → Track
Genre → Track
MediaType → Track
Track → InvoiceLine

Many-to-Many:
Playlist ↔ Track (via PlaylistTrack).

One-to-One:
Not explicitly present (though Employee self-reporting can mimic hierarchy but not strictly one-to-one).
Not explicitly present (though Employee self-reporting can mimic hierarchy but not strictly one-to-one).
