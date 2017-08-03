Date: Thu, 3 Aug 2017 10:47:46 -0400
From: Jerome Glisse <jglisse@redhat.com>
Message-ID: <20170803144746.GA9501@redhat.com>
References: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
 <20170802170848.GA3240@redhat.com>
 <8e82639c-40db-02ce-096a-d114b0436d3c@huawei.com>
 <20170803114844.GO12521@dhcp22.suse.cz>
 <c3a250a6-ad4d-d24d-d0bf-4c43c467ebe6@huawei.com>
 <20170803135549.GW12521@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170803135549.GW12521@dhcp22.suse.cz>
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Michal Hocko <mhocko@kernel.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 03, 2017 at 03:55:50PM +0200, Michal Hocko wrote:
> On Thu 03-08-17 15:20:31, Igor Stoppa wrote:
> > On 03/08/17 14:48, Michal Hocko wrote:
> > > On Thu 03-08-17 13:11:45, Igor Stoppa wrote:
> > >> On 02/08/17 20:08, Jerome Glisse wrote:
> > >>> On Wed, Aug 02, 2017 at 06:14:28PM +0300, Igor Stoppa wrote:
> > 
> > [...]
> > 
> > >>>> from include/linux/mm_types.h:
> > >>>>
> > >>>> struct page {
> > >>>> ...
> > >>>>   union {
> > >>>>     unsigned long private;		/* Mapping-private opaque data:
> > >>>> 				 	 * usually used for buffer_heads
> > >>>> 					 * if PagePrivate set; used for
> > >>>> 					 * swp_entry_t if PageSwapCache;
> > >>>> 					 * indicates order in the buddy
> > >>>> 					 * system if PG_buddy is set.
> > >>>> 					 */
> > 
> > [...]
> > 
> > >> If the "Mapping-private" was dropped or somehow connected exclusively to
> > >> the cases listed in the comment, then I think it would be more clear
> > >> that the comment needs to be intended as related to mapping in certain
> > >> cases only.
> > >> But it is otherwise ok to use the "private" field for whatever purpose
> > >> it might be suitable, as long as it is not already in use.
> > > 
> > > I would recommend adding a new field into the enum...
> > 
> > s/enum/union/ ?
> > 
> > If not, I am not sure what is the enum that you are talking about.
> 
> yeah, fat fingers on my side
> 
> > 
> > [...]
> > 
> > >> But, to reply more specifically to your advice, yes, I think I could add
> > >> a flag to vm_struct and then retrieve its value, for the address being
> > >> processed, by passing through find_vm_area().
> > > 
> > > ... and you can store vm_struct pointer to the struct page there 
> > 
> > "there" as in the new field of the union?
> > btw, what would be a meaningful name, since "private" is already taken?
> > 
> > For simplicity, I'll use, for now, "private2"
> 
> why not explicit vm_area?
> 
> > > and you> won't need to do the slow find_vm_area. I haven't checked
> > very closely
> > > but this should be possible in principle. I guess other callers might
> > > benefit from this as well.
> > 
> > I am confused about this: if "private2" is a pointer, but when I get an
> > address, I do not even know if the address represents a valid pmalloc
> > page, how can i know when it's ok to dereference "private2"?
> 
> because you can make all pages which back vmalloc mappings have vm_area
> pointer set.

Note that i think this might break some device driver that use vmap()
i think some of them use private field to store device driver specific
informations. But there likely is an unuse field in struct page that
can be use for that.

Jérôme
