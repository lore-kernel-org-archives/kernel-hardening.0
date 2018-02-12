Subject: Re: [PATCH 4/6] Protectable Memory
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-5-igor.stoppa@huawei.com>
 <20180211123743.GC13931@rapoport-lnx>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <e7ea02b4-3d43-9543-3d14-61c27e155042@huawei.com>
Date: Mon, 12 Feb 2018 13:26:28 +0200
MIME-Version: 1.0
In-Reply-To: <20180211123743.GC13931@rapoport-lnx>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/02/18 14:37, Mike Rapoport wrote:
> On Sun, Feb 11, 2018 at 05:19:18AM +0200, Igor Stoppa wrote:

>> + * Return: 0 if the object does not belong to pmalloc, 1 if it belongs to
>> + * pmalloc, -1 if it partially overlaps pmalloc meory, but incorectly.
> 
> typo:                                            ^ memory

thanks :-(

[...]

>> +/**
>> + * When the sysfs is ready to receive registrations, connect all the
>> + * pools previously created. Also enable further pools to be connected
>> + * right away.
>> + */
> 
> This does not seem as kernel-doc comment. Please either remove the second *
> from the opening comment mark or reformat the comment.

For this too, I thought I had caught them all, but I was wrong ...

I didn't find any mention of automated checking for comments.
Is there such tool?

--
thanks, igor
