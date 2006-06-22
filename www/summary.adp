
<if @communities:rowcount@ gt 0>
  <UL>
  <multiple name="communities">
    <LI><a href="@communities.url@"> @communities.mmptitle@</a> (@communities.pretty_name@, @communities.bd@ -> @communities.ed@)
  </multiple>
  </UL>
</if>
