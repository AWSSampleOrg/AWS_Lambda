# Disable the ESM and enable it back, would it continue to process the records it last processed after disabled ?

If the ESM is disabled and enabled again, Lambda will pick off from where it stopped processing records and continue processing the remaining.
This is not in case of deleting and re-creating the ESM.

# Delete the ESM and re-create it again. Missing some data because of starting position of ESM.

This behavior means that if you specify LATEST as the starting position for the stream, the event source mapping could miss events during creation or updates. To ensure that no events are missed, specify the stream starting position as TRIM_HORIZON or AT_TIMESTAMP.

# You can set starting position only when you create an ESM, not when updating.
