References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <302be94d-7e44-001d-286c-2b0cd6098f7b@huawei.com>
 <20170911145020.fat456njvyagcomu@docker>
 <57e95ad2-81d8-bf83-3e78-1313daa1bb80@canonical.com>
 <431e2567-7600-3186-1489-93b855c395bd@huawei.com>
 <20170912143636.avc3ponnervs43kj@docker>
 <20170912181303.aqjj5ri3mhscw63t@docker>
 <91923595-7f02-3be0-9c59-9c1fd20c82a8@intel.com>
 <20170921000210.drjiywtp4n75yovk@docker>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <21bcc50a-f333-fb43-adef-ed501fc6b127@intel.com>
Date: Wed, 20 Sep 2017 17:04:35 -0700
MIME-Version: 1.0
In-Reply-To: <20170921000210.drjiywtp4n75yovk@docker>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Tycho Andersen <tycho@docker.com>
Cc: Yisheng Xie <xieyisheng1@huawei.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 09/20/2017 05:02 PM, Tycho Andersen wrote:
> ...and makes it easier to pair tlb flushes with changing the
> protections. I guess we still need the for loop, because we need to
> set/unset the xpfo bits as necessary, but I'll switch it to a single
> set_kpte(). This also implies that the xpfo bits should all be the
> same on every page in the mapping, which I think is true.

FWIW, it's a bit bonkers to keep all this duplicate xpfo metadata for
compound pages.  You could probably get away with only keeping it for
the head page.
