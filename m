Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
References: <20180227111532.1144-1-ppandit@redhat.com>
 <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
 <f5f8d06d-461f-f4ad-bc32-5a18f5359353@redhat.com>
 <CAGXu5j+rEo9u4CoNBz+Y-HDCqX5=mv__0Wvru6tJRgri2r2BUQ@mail.gmail.com>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <d93ce6b7-9057-4934-94ae-c3ae3555b434@redhat.com>
Date: Wed, 28 Feb 2018 09:25:50 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+rEo9u4CoNBz+Y-HDCqX5=mv__0Wvru6tJRgri2r2BUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
Cc: P J P <ppandit@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/28/2018 12:38 AM, Kees Cook wrote:
> That's a surprisingly small text change! I'd love to see benchmarks
> too.

When we benchmarked this a while back, we saw a measurable performance 
hit for processing small packet processing (both UDP and TCP).  I 
assumed this was due to the initialization of the socket address 
structure.  Unfortunately, this was a place where past leaks happened.

My feeling at the time was that the return path for the socket address 
would have to be overhauled, such that returning a partially initialized 
result would be prevent by the API, without having to clear the entire 
return buffer.

Apart from that, we didn't see any changes in performance.

> Are you able to verify this is initializing the
> passed-by-reference variables too?

Shouldn't the initialization happen in the caller?

Thanks,
Florian
