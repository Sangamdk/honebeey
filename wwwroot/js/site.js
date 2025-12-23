// Update cart count on page load
$(document).ready(function() {
    updateCartCount();
});

function updateCartCount() {
    $.get('/Cart/GetCount', function(data) {
        $('#cart-count').text(data.count || 0);
    });
}

// Add to cart function
function addToCart(productId, quantity = 1) {
    $.post('/Cart/Add', { productId: productId, quantity: quantity })
        .done(function(data) {
            if (data.success) {
                $('#cart-count').text(data.cartCount);
                alert('Product added to cart!');
            } else {
                alert(data.message || 'Failed to add product to cart');
            }
        })
        .fail(function() {
            alert('An error occurred while adding to cart');
        });
}

// Update cart quantity
function updateCartQuantity(productId, quantity) {
    $.post('/Cart/Update', { productId: productId, quantity: quantity })
        .done(function(data) {
            if (data.success) {
                $('#cart-count').text(data.cartCount);
                location.reload(); // Reload to update totals
            } else {
                alert(data.message || 'Failed to update cart');
            }
        })
        .fail(function() {
            alert('An error occurred while updating cart');
        });
}

