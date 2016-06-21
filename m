Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160621084649.GC30848@dhcp22.suse.cz>
References: <cover.1466192946.git.luto@kernel.org> <44f658aacbabd9d1689b3e0aae60ee8746881eff.1466192946.git.luto@kernel.org>
 <20160620133614.GE9892@dhcp22.suse.cz> <CALCETrV3M0a4Xyro21Rz8gpkq1b8PnFUZm_NPnBr0BBO8HS6ug@mail.gmail.com>
 <20160621084649.GC30848@dhcp22.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Jun 2016 10:01:06 -0700
Message-ID: <CALCETrXqH1J5qwKhm7V2E1nfx2LWnkvG7DxYdd2NP5Sp6j+JfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2 06/13] fork: Add generic vmalloced stack support
To: Michal Hocko <mhocko@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 1:46 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 20-06-16 09:13:55, Andy Lutomirski wrote:
>> On Mon, Jun 20, 2016 at 6:36 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Fri 17-06-16 13:00:42, Andy Lutomirski wrote:
>> >> If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
>> >> vmalloc_node.
>> >
>> > I like this! It also reduces demand for higher order (order-2) pages
>> > considerably which is a great plus on its own. I would be little bit
>> > worried about the performance because vmalloc wasn't the fastest one
>> > AFAIR. Have you tried to measure that?
>>
>> It seems to add about 1.5=E7=9B=9C to pthread_create+join on my laptop. =
 (On
>> an unmodified, stripped-down kernel, it took about 7=E7=9B=9C before.  O=
n a
>> Fedora system, the baseline is much worse.)  I think that most of the
>> overhead is because vmalloc allocates one page at a time, which means
>> that it won't use a higher order page even if one is sitting on a
>> freelist.
>
> I guess a less artificial test case which would would generate a lot of
> tasks and some memory pressure would be more representative (e.g.
> kernbench). The thing is that even order-2 pages might get quite
> expensive when the memory is fragmented.
>
>> I can imagine better integration with the page allocator in which
>> higher order pages are used if readily available.  Similarly, vfree
>> could free pages that happen to be aligned and consecutive as a unit
>> to avoid the overhead of merging them back together one at a time.
>>
>> But I'm not planning on doing any of this myself any time soon.  I
>> just want to get the code working and merged.
>
> I agree, there is a room for improvement but no necessarily as a part of
> this series.
>

Agreed.  My goal is to get this good enough for upstream, and we can
make it even better down the road.

That being said, I think I will implement Linus' suggestion of a tiny
percpu cache.

--Andy
