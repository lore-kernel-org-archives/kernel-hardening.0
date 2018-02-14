MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1518634058.3678.15.camel@perches.com>
References: <20180214182618.14627-1-willy@infradead.org> <1518634058.3678.15.camel@perches.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 14 Feb 2018 11:23:47 -0800
Message-ID: <CAGXu5jJdAJt3HK7FgaCyPRbXeFV-hJOrPodNnOkx=kCvSieK3w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add kvzalloc_struct to complement kvzalloc_array
Content-Type: text/plain; charset="UTF-8"
To: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 14, 2018 at 10:47 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2018-02-14 at 10:26 -0800, Matthew Wilcox wrote:
>> From: Matthew Wilcox <mawilcox@microsoft.com>
>>
>> We all know the perils of multiplying a value provided from userspace
>> by a constant and then allocating the resulting number of bytes.  That's
>> why we have kvmalloc_array(), so we don't have to think about it.
>> This solves the same problem when we embed one of these arrays in a
>> struct like this:
>>
>> struct {
>>       int n;
>>       unsigned long array[];
>> };
>
> I think expanding the number of allocation functions
> is not necessary.

I think removing common mispatterns in favor of overflow-protected
allocation functions makes sense.

-Kees

-- 
Kees Cook
Pixel Security
