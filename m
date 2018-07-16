Subject: Re: [PATCH v7] add param that allows bootline control of hardened
 usercopy
References: <1530646988-25546-1-git-send-email-crecklin@redhat.com>
 <b1bfe507-3dda-fccb-5355-26f6cce9fa6a@suse.cz>
 <CAGXu5jJa=jEZmRQa6TYuOFORHs_nYvQAO3Q3Hv5vz4tsHd00nQ@mail.gmail.com>
 <0bf9be39-82bb-ad3a-a3c3-e41bebedba7e@suse.cz>
 <CAGXu5jLcx7iFNJGL9=LStCGCq6gx2D7onJAmHsKK3Vxe2pJvdg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5e08d6ab-00dd-1d1c-3a2f-32761bc51d28@suse.cz>
Date: Mon, 16 Jul 2018 13:30:20 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLcx7iFNJGL9=LStCGCq6gx2D7onJAmHsKK3Vxe2pJvdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Chris von Recklinghausen <crecklin@redhat.com>, Laura Abbott <labbott@redhat.com>, Paolo Abeni <pabeni@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/15/2018 04:04 AM, Kees Cook wrote:
> On Wed, Jul 4, 2018 at 10:47 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>> On 07/04/2018 06:52 PM, Kees Cook wrote:
>>> This produces less efficient code in the general case, and I'd like to
>>> keep the general case (hardening enabled) as fast as possible.
>>
>> How specifically is the code less efficient? It should be always a
>> static key check (no-op thanks to the code patching involved) and a
>> function call in the "hardening enabled" case, just in different order.
>> And in either case compiled out if it's a constant.
> 
> My understanding from reading the jump label comments[1] is that on
> order produces:
> 
> NOP
> do normal thing
> label1:
> do rest of function
> RET
> label2:
> do exceptional thing
> jump label1
> 
> where "NOP" is changed to "JMP label2" when toggled, and the other is:
> 
> JMP label1
> do exceptional thing
> JMP label2
> label1:
> do normal thing
> label2:
> do rest of function
> RET
> 
> where "JMP label1" is changed to NOP when toggled. (i.e. does the
> default do NOP, thing, function, or does the default to JMP, thing,
> JMP, function)

My mistake, sorry. I didn't mean to change likely() to unlikely(). Also
I didn't negate the condition. The correct code is:

        if (!__builtin_constant_p(n) &&
                        !static_branch_unlikely(&bypass_usercopy_checks))
                __check_object_size(ptr, n, to_user);

I've test-compiled it, did objdump -d and checked few call sites and they
seem to be preceded just y NOP, so it's the first case you mentioned above,
as expected - calling __check_object_size() is treated as the "normal thing".
