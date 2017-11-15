Date: Tue, 14 Nov 2017 16:42:41 -0800
From: Tycho Andersen <tycho@tycho.ws>
Message-ID: <20171115004241.x26in64ruukitrjb@cisco>
References: <34454a32-72c2-c62e-546c-1837e05327e1@intel.com>
 <20170920223452.vam3egenc533rcta@smitten>
 <97475308-1f3d-ea91-5647-39231f3b40e5@intel.com>
 <20170921000901.v7zo4g5edhqqfabm@docker>
 <d1a35583-8225-2ab3-d9fa-273482615d09@intel.com>
 <20171110010907.qfkqhrbtdkt5y3hy@smitten>
 <7237ae6d-f8aa-085e-c144-9ed5583ec06b@intel.com>
 <2aa64bf6-fead-08cc-f4fe-bd353008ca59@intel.com>
 <20171115003358.r3bsukc3vlbikjef@cisco>
 <c9516f27-ad4c-5b65-1611-f0c3604168bf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9516f27-ad4c-5b65-1611-f0c3604168bf@intel.com>
Subject: Re: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for
 eXclusive Page Frame Ownership (XPFO)
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 14, 2017 at 04:37:34PM -0800, Dave Hansen wrote:
> On 11/14/2017 04:33 PM, Tycho Andersen wrote:
> >>
> >> void set_bh_page(struct buffer_head *bh,
> >> ...
> >> 	bh->b_data = page_address(page) + offset;
> > Ah, yes. I guess there will be many bugs like this :). Anyway, I'll
> > try to cook up a patch.
> 
> It won't catch all the bugs, but it might be handy to have a debugging
> mode that records the location of the last user of page_address() and
> friends.  That way, when we trip over an unmapped page, we have an
> easier time finding the offender.

Ok, what I've been doing now is saving the stack frame of the code
that allocated the page, which also seems useful. I'll see about
adding a DEBUG_XPFO config option for the next series with both of
these things, though.

Cheers,

Tycho
