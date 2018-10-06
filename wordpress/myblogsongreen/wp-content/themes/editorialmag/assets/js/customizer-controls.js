jQuery(window).load(function() {
    var upgrade_notice = '<a class="editorialmag-pro" target="_blank" href="https://sparklewpthemes.com/wordpress-themes/editorialmag">UPGRADE TO EDITORIALMAG PRO</a>';
    upgrade_notice += '<a class="editorialmag-pro" target="_blank" href="http://demo.sparklewpthemes.com/editorialmag/demos/">EDITORIALMAG PRO DEMO</a>';
    jQuery('#customize-info .preview-notice').append(upgrade_notice);
});

(function ($) {
    jQuery(document).ready(function ($) {


        $('.sparkle-customizer').on( 'click', function( evt ){
            evt.preventDefault();
            section = $(this).data('section');
            if ( section ) {
                wp.customize.section( section ).focus();
            }
        });

    });
})(jQuery);