export function deleteUser(userId) {
    if (!window.Swal) {
        console.error("SweetAlert2 is not loaded!");
        return;
    }

    window.Swal.fire({
        title: 'delete this user?',
        text: "are you sure you want to delete this user? this action cannot be undone.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#4f46e5',
        cancelButtonColor: '#ef4444',
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        reverseButtons: true,
        borderRadius: '1.5rem'
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.getElementById('delete-form-' + userId);
            if (form) {
                form.submit();
            }
        }
    });
}

window.deleteUser = deleteUser;