var current_edge = {};

function markClass(id, className, enabled) {
  if (id && className) {
    d3.select("#"+id).classed(className, enabled);
  }
}

function displayRelations(datum, nodeClass, enabled) {
  if (!datum)
    return;
  markClass(datum.id, nodeClass, enabled);
  for(var n in datum) {
    if(n != "desc" && n != "id") {
      markClass(datum[n], n, enabled);
    }
  }
  var desc = enabled ? (datum.desc || "") : "";
  d3.select("#desc ."+nodeClass).html(desc);
}

function extractDatum(node, datum) {
  var info = d3.select(node).select("a");
  if (info && info[0] && info[0][0]) {
    info = info.attr("xlink:title");
  } else {
    info = null;
  }
  if (info) {
    var attrs = info.split("|");
    // class:id:filename - class = (config|client|server|client_config|server_config)
    for(var attr_num = 0; attr_num < attrs.length ; attr_num++) {
      var attr = attrs[attr_num].trim();
      attr_parts = attr.split(":");
      if (attr_parts[1]) {
        // TODO: handle duplicate attributes?
        datum[attr_parts[0]] = attr_parts[1];
        // TODO: add specific support for 3rd parameter (tablename/filename)
        // if (attr_parts[2])
        //   attr["filename"] = attr_parts[2];
      } else {
        datum["desc"] = attr_parts[0];
      }
    }
  }
  return datum;
}

/* work around dot not supporting attribute `class="x"` */
function hackClass(node, datum) {
  if (datum["class"]) {
    d3.select(node).classed(datum["class"], true);
    delete datum["class"];
  }
  return datum;
}

d3.selectAll(".node").datum(function() {
  return hackClass(this, extractDatum(this, {"id" : this.id}));
})
.on('mouseover', function(datum) {
  displayRelations(datum, 'active', true);
})
.on('mouseout', function(datum) {
  displayRelations(datum, 'active', false);
});

d3.selectAll(".edge").datum(function(){
  return extractDatum(this, {"id" : this.id});
})
/*  selecting an edge is difficult
 *  instead of relying upon mouseover/mouseout, making mouseover sticky
 */
.on('mouseover', function(datum) {
  if (datum.id != current_edge.id) {
    displayRelations(current_edge, 'src-dest', false);
    current_edge = datum;
    displayRelations(datum, 'src-dest', true);
  }
});
