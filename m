References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
 <20171122132235.GA30635@bombadil.infradead.org>
From: Pavel Vasilyev <dixlor@gmail.com>
Message-ID: <44203c85-f64f-4ae4-e179-28d50e11c82a@gmail.com>
Date: Wed, 22 Nov 2017 17:38:31 +0300
MIME-Version: 1.0
In-Reply-To: <20171122132235.GA30635@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in
 sticky directories
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



22.11.2017 16:22, Matthew Wilcox пишет:

> 
> So you'd have the following meaningful values:
> 
>  0 - permit all (your option 0)
>  1 - notify world; permit group (your option 1)
>  2 - block world; permit group
>  3 - block,notify world; permit group
>  4 - permit world; notify group (?)
>  5 - notify world; notify group (your option 2)
>  6 - block world; notify group (your option 3)
>  7 - block,notify world; notify group
>  8 - permit world; block group (?)
>  9 - notify world; block group (?)
> 10 - block world; block group (your option 4)
> 11 - block,notify world; block group
> 12 - permit world; block, notify group (?)
> 13 - notify world; block, notify group (?)
> 14 - block world; block, notify group
> 15 - block, notify world; block, notify group
> 
> Some of these don't make a lot of sense (marked with ?), but I don't see
> the harm in permitting a sysadmin to do something that seems nonsensical
> to me.
> 

I think that notification in block mode by default.
