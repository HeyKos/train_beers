type DocData = FirebaseFirestore.DocumentData;
type DocRef = FirebaseFirestore.DocumentReference<DocData>;

export interface EventParticipant {
    event: DocRef;
    user: DocRef;
}
