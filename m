Subject: Re: [RFC][PATCH 00/13] Provide saturating helpers for allocation
References: <20180509004229.36341-1-keescook@chromium.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <4baffc55-510e-96d3-3487-5ea09f993a0c@redhat.com>
Date: Wed, 9 May 2018 09:08:24 -0700
MIME-Version: 1.0
In-Reply-To: <20180509004229.36341-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Matthew Wilcox <mawilcox@microsoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/08/2018 05:42 PM, Kees Cook wrote:
> This is a stab at providing three new helpers for allocation size
> calculation:
> 
> struct_size(), array_size(), and array3_size().
> 
> These are implemented on top of Rasmus's overflow checking functions,
> and the last 8 patches are all treewide conversions of open-coded
> multiplications into the various combinations of the helper functions.
> 
> -Kees
> 
> 
Obvious question (that might indicate this deserves documentation?)

What's the difference between

kmalloc_array(cnt, sizeof(struct blah), GFP_KERNEL);

and

kmalloc(array_size(cnt, struct blah), GFP_KERNEL);


and when would you use one over the other?

Thanks,
Laura
