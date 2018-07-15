MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <0bf9be39-82bb-ad3a-a3c3-e41bebedba7e@suse.cz>
References: <1530646988-25546-1-git-send-email-crecklin@redhat.com>
 <b1bfe507-3dda-fccb-5355-26f6cce9fa6a@suse.cz> <CAGXu5jJa=jEZmRQa6TYuOFORHs_nYvQAO3Q3Hv5vz4tsHd00nQ@mail.gmail.com>
 <0bf9be39-82bb-ad3a-a3c3-e41bebedba7e@suse.cz>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 14 Jul 2018 19:04:07 -0700
Message-ID: <CAGXu5jLcx7iFNJGL9=LStCGCq6gx2D7onJAmHsKK3Vxe2pJvdg@mail.gmail.com>
Subject: Re: [PATCH v7] add param that allows bootline control of hardened usercopy
Content-Type: text/plain; charset="UTF-8"
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Chris von Recklinghausen <crecklin@redhat.com>, Laura Abbott <labbott@redhat.com>, Paolo Abeni <pabeni@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 4, 2018 at 10:47 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 07/04/2018 06:52 PM, Kees Cook wrote:
>> This produces less efficient code in the general case, and I'd like to
>> keep the general case (hardening enabled) as fast as possible.
>
> How specifically is the code less efficient? It should be always a
> static key check (no-op thanks to the code patching involved) and a
> function call in the "hardening enabled" case, just in different order.
> And in either case compiled out if it's a constant.

My understanding from reading the jump label comments[1] is that on
order produces:

NOP
do normal thing
label1:
do rest of function
RET
label2:
do exceptional thing
jump label1

where "NOP" is changed to "JMP label2" when toggled, and the other is:

JMP label1
do exceptional thing
JMP label2
label1:
do normal thing
label2:
do rest of function
RET

where "JMP label1" is changed to NOP when toggled. (i.e. does the
default do NOP, thing, function, or does the default to JMP, thing,
JMP, function)

-Kees

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/jump_label.h#n334

-- 
Kees Cook
Pixel Security
