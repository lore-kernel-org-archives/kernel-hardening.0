From: Dave Hansen <dave.hansen@intel.com>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <34454a32-72c2-c62e-546c-1837e05327e1@intel.com>
 <20170920223452.vam3egenc533rcta@smitten>
 <97475308-1f3d-ea91-5647-39231f3b40e5@intel.com>
 <20170921000901.v7zo4g5edhqqfabm@docker>
 <d1a35583-8225-2ab3-d9fa-273482615d09@intel.com>
 <20171110010907.qfkqhrbtdkt5y3hy@smitten>
 <7237ae6d-f8aa-085e-c144-9ed5583ec06b@intel.com>
Message-ID: <2aa64bf6-fead-08cc-f4fe-bd353008ca59@intel.com>
Date: Mon, 13 Nov 2017 14:46:25 -0800
MIME-Version: 1.0
In-Reply-To: <7237ae6d-f8aa-085e-c144-9ed5583ec06b@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 11/13/2017 02:20 PM, Dave Hansen wrote:
> On 11/09/2017 05:09 PM, Tycho Andersen wrote:
>> which I guess is from the additional flags in grow_dev_page() somewhere down
>> the stack. Anyway... it seems this is a kernel allocation that's using
>> MIGRATE_MOVABLE, so perhaps we need some more fine tuned heuristic than just
>> all MOVABLE allocations are un-mapped via xpfo, and all the others are mapped.
>>
>> Do you have any ideas?
> 
> It still has to do a kmap() or kmap_atomic() to be able to access it.  I
> thought you hooked into that.  Why isn't that path getting hit for these?

Oh, this looks to be accessing data mapped by a buffer_head.  It
(rudely) accesses data via:

void set_bh_page(struct buffer_head *bh,
...
	bh->b_data = page_address(page) + offset;
