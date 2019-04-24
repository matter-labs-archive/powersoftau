cd /app/
cargo build --release --bin new_constrained
cargo build --release --bin compute_constrained
cargo build --release --bin beacon_constrained
cargo build --release --bin verify_transform_constrained
cd -