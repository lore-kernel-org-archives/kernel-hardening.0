MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <14a4ef2b-1a32-2781-80db-ee850e25f318@redhat.com>
References: <20180227111532.1144-1-ppandit@redhat.com> <20180227111532.1144-2-ppandit@redhat.com>
 <14a4ef2b-1a32-2781-80db-ee850e25f318@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Feb 2018 11:33:34 -0800
Message-ID: <CAGXu5j+_biDq6xzgB0mAEm159mFc5fABfqOT4-Yew9t-YdNuvg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Add an option to build kernel with -finit-local-vars
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: P J P <ppandit@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 27, 2018 at 11:22 AM, Laura Abbott <labbott@redhat.com> wrote:
> On 02/27/2018 03:15 AM, P J P wrote:
>> Add a configuration option to build kernel with -finit-local-vars
>> compiler option.[*] It'll zero initialize the automatic kernel
>> function variables, thus helping to reduce kernel information
>> leakage issues.
>
> I think this would make the existing structleak plugin
> (scripts/gcc-plugins/structleak_plugin.c) obsolete. This isn't
> a bad thing but we'd need to figure out a deprecation strategy.

It would be nice to make it obsolete, but I don't think that'll happen
right away. We still have issues with structure padding,
passed-by-reference init, and possibly performance. I wouldn't want to
rule anything out until we can have both more complete coverage and
better benchmarks (e.g. this is wipe-before, not wipe-after, so there
may be cache effects, etc).

-Kees

-- 
Kees Cook
Pixel Security
