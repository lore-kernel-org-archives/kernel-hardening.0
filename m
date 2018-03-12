MIME-Version: 1.0
In-Reply-To: <20180312050623.GD8631@eros>
References: <1520830180-25452-1-git-send-email-me@tobin.cc>
 <20180312050204.GC25480@zzz.localdomain> <20180312050623.GD8631@eros>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 12 Mar 2018 10:57:08 +0100
Message-ID: <CAOi1vP-TrD9xp4ottwSUEx=h_-uLOYs5BuEMAgSJrK2gmdZoDg@mail.gmail.com>
Subject: Re: [PATCH] rbd: Remove VLA stack usage
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Eric Biggers <ebiggers3@gmail.com>, Sage Weil <sage@redhat.com>, Alex Elder <elder@kernel.org>, Ceph Development <ceph-devel@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 6:06 AM, Tobin C. Harding <me@tobin.cc> wrote:
> On Sun, Mar 11, 2018 at 10:02:04PM -0700, Eric Biggers wrote:
>> On Mon, Mar 12, 2018 at 03:49:40PM +1100, Tobin C. Harding wrote:
>> > The kernel would like to have all stack VLA usage removed[1].
>>
>> Can you please stop writing this?  The Linux kernel isn't sentient; it doesn't
>> "like" anything.  You need to explain why *you* (and other people) believe these
>> changes should be made.
>
> No worries, will re-spin with better description.

I'd prefer a single patch covering both functions.

Also, as these are char arrays, use sizeof instead of ARRAY_SIZE.

Thanks,

                Ilya
