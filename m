Message-ID: <1518643659.3678.34.camel@perches.com>
Subject: Re: [PATCH v2 2/8] mm: Add kvmalloc_ab_c and kvzalloc_struct
From: Joe Perches <joe@perches.com>
Date: Wed, 14 Feb 2018 13:27:39 -0800
In-Reply-To: <1518643449.3678.33.camel@perches.com>
References: <20180214201154.10186-1-willy@infradead.org>
	 <20180214201154.10186-3-willy@infradead.org>
	 <1518641152.3678.28.camel@perches.com>
	 <20180214211203.GF20627@bombadil.infradead.org>
	 <1518643449.3678.33.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2018-02-14 at 13:24 -0800, Joe Perches wrote:
> Look at your patch 4
> 
> -       dev_dax = kzalloc(sizeof(*dev_dax) + sizeof(*res) * count, GFP_KERNEL);
> +       dev_dax = kvzalloc_struct(dev_dax, res, count, GFP_KERNEL);
> 
> Here what is being allocated is exactly a struct
> and an array.
> 
> And this doesn't compile either.

apologies,  my mistake.
