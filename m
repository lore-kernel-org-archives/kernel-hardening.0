Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160406205429.GA13901@kroah.com>
References: <1459971348-81477-1-git-send-email-thgarnie@google.com>
	<20160406205429.GA13901@kroah.com>
Date: Wed, 6 Apr 2016 14:03:22 -0700
Message-ID: <CAJcbSZFs3wJ3hEkvWoLH-9h+Dk_mTCfRUnH7o1JvcS-5AGY3kQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v1] mm: SLAB freelist randomization
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

Yes, sorry about that. It will be in the next RFC or PATCH.

On Wed, Apr 6, 2016 at 1:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Apr 06, 2016 at 12:35:48PM -0700, Thomas Garnier wrote:
>> Provide an optional config (CONFIG_FREELIST_RANDOM) to randomize the
>> SLAB freelist. This security feature reduces the predictability of
>> the kernel slab allocator against heap overflows.
>>
>> Randomized lists are pre-computed using a Fisher-Yates shuffle and
>> re-used on slab creation for performance.
>> ---
>> Based on next-20160405
>> ---
>
> No signed-off-by:?
>
