/* =============================================================================
 *
 * jQuery BMJ Utils Expand and Collaps
 * Version 1.0
 * Expands and Collapsea a set of elements'sub elements.
 * 
 *
 * Author: Zoe Azhdari Radkani
 * Author email: ZAzhdariRadkani@bmjgroup.com
 * 
 * Versy simple and easy to use. Works only by adding a few changes to the html
 * and stylesheet. Perfect for when you have a list of long things to display.
 * Wrap each item of the list in <dl class="expandable"> (important to use
 * exactly the same class name) the wrap the title in <dt> and the content with
 * <dd>. Then at the end wrap the whole list in a <div class="allopenable">.
 * Any where inside the div.allopenable you can have the "Show all" link, just
 * include <span class="showall">show all</span>.
 *
 * See example for more details.
 * ---------------------------------------------------------------------------
 * 
 * EXAMPLES OF USE:
 * 
 *    <div class="allopenable">
 *
 *
 *    <span class="showall">show all</span>  
 *
 *    <dl class="expandable">
 *          <dt>GORD</dt>
 *         <dd style="display: none;">
 *          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. ifend vel rhoncus nisi auctor.</p>
 *         </dd>           
 *    </dl>
 *      .
 *      .
 *      .
 *
 *    <dl class="expandable">
 *     <dt>SAGITTIS</dt>
 *     <dd style="display: none;">
 *        <p>Proin feugiat lorem et felis rutrum a elementum tellus feugiat ac luctus lorem dignissim tristique. </p>
 *     </dd>           
 *     </dl>
 *     <dl class="expandable">
 *       <dt>FUSCE</dt>
 *       <dd style="display: none;">
 *         <p>In vulputate ornare felis. Vestibulum nisi purus, eleifend inar sit amet, molestie non erat.</p>
 *       </dd>           
 *     </dl>
 *   </div> 
 * 
 *------------------------------------------------------------------------------
 *
 * Note: it's optional to add 'style="display: none;"' to <dd>s, as the plugin
 * set the visibitly to none after the page is loaded. but to mask any loading
 * delays it is better to set the visibility inside the html . There for the users
 * won't experiance the little jump after the page is loaded .
 * 	       
 =============================================================================*/
//Creating closure
(function($) {
     //plug-in definition
    $.fn.enableExpandables = function() {
         // Collapse the subsections
        jQuery(".expandable dd").hide();
        // Apply styles
        jQuery(".expandable dt").css("cursor", "pointer").addClass("collapsed");
        jQuery(".expandable dt").each( function() {
            setExpandableStyleClass(this);
        });
        // Set the click event handler on subsections.
        jQuery(".expandable dt").click( function(e) {
            // e.target could be the dt or could be a sub-element:
            clickedThing(e, "dt").next("dd").toggle();
            setExpandableStyleClass(this);
        });
        jQuery(".expandable dt").keydown( function(e) {
        if (e.keyCode == 13) {
            // e.target could be the dt or could be a sub-element:
            clickedThing(e, "dt").next("dd").toggle();
            setExpandableStyleClass(this);
            }
        });
        // add buttons to show/hide all:
        jQuery(".expandable").each(
            function() {
                jQuery(this).parents("div.allopenable").slice(0, 1).click(showall).keydown(function(f){
                 if (f.keyCode == 13) {
                  showall(f)
                  }
                }).end().removeClass("allopenable");              
            });
    };
    
    /* 
     * Expands the expandable section based on the anchor in the URL.
     * The anchor id has to be expsec-? where ? can be any number.
     * The anchor has to be a direct child of the expandable dt element.
     */
    function expandDefaultExpandable() {
       var hash = location.hash;
       if (hash.indexOf("expsec") != -1) {
           jQuery(hash).parents("dt").click();
       }
    }

    /* 
     * Checks the related dd of the 'expandableElement' node is hidden 
     * and sets it's style class accordingly.
     * and sets it's style class accordingly. 
     */
    function setExpandableStyleClass(expandableElement) {
        var isHidden = jQuery(expandableElement).next("dd").is(":hidden");
        if (isHidden)      
        {
            jQuery(expandableElement).addClass("collapsed");
            jQuery(expandableElement).removeClass("expanded");
        } else {
            jQuery(expandableElement).addClass("expanded");
            jQuery(expandableElement).removeClass("collapsed");
        }
    }
    
    function clickedThing(e,$type) {
	var el = $(e.target);
	if (!el.is($type)) {
		el = el.parents($type).slice(0, 1);
	}
        return el;	
    }
    
    var showall = function(e) {
        e.stopPropagation();
        var target = clickedThing(e, "button.showall");
        if (target.length == 0)
        {
            return;
        }
        
        target.addClass("collapse-all");
        target.removeClass("expand-all");
        // Hide the subsections and set the style class on the 'dt' element.
        target.parents("div").slice(0, 1).find(".expandable dd").show();
        target.parents("div").slice(0,1).find(".expandable dt")
            .each(function () { setExpandableStyleClass(this); });
       
        target.unbind("click", showall).text("collapse all deleted changes").click(closeall); 
        target.unbind("keydown", showallEnter).text("collapse all deleted changes").keydown(closeallEnter);   
        
        
    }
    
    var closeall = function(e) {
        e.stopPropagation();
        var target = clickedThing(e, "button.showall");
        if (target.length == 0)
        {
            return;
        }
        target.addClass("expand-all");
        target.removeClass("collapse-all");
        // Hide the subsections and set the style class on the 'dt' element.
        target.parents("div").slice(0, 1).find(".expandable dd").hide();
        target.parents("div").slice(0,1).find(".expandable dt")
            .each(function () { setExpandableStyleClass(this); });
        
        target.unbind("click", closeall).text("expand all deleted changes").click(showall);
        target.unbind("keydown", closeallEnter).text("expand all deleted changes").keydown(showallEnter);
    
    }
        
    var closeallEnter = function(e){
            if (e.keyCode == 13) {
                    closeall(e)
                    }
    }
    
    var showallEnter = function(e){
        if (e.keyCode == 13) {
                showall(e)
                }
    }

})(jQuery);




