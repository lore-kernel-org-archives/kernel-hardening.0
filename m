Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <5165502902000078000CC022@nat28.tlf.novell.com>
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com> <alpine.LFD.2.02.1304091122490.21884@ionos> <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com> <51645D6F.7070705@zytor.com> <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com> <51646054.3090509@zytor.com> <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com> <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com> <5164B5BD.5050702@zytor.com> <5165502902000078000CC022@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 10 Apr 2013 07:16:33 -0700
Message-ID: <4a955c26-e4f2-40da-9ddc-6aaaf766d8da@email.android.com>
Subject: [kernel-hardening] Re: [Xen-devel] Readonly GDT
To: Jan Beulich <JBeulich@suse.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Alex Shi <alex.shi@intel.com>, Alexander Duyck <alexander.h.duyck@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Dan Rosenberg <drosenberg@vsecurity.com>
List-ID: <kernel-hardening.lists.openwall.com>

Right... the TSS does get written to during a task switch.

Jan Beulich <JBeulich@suse.com> wrote:

>>>> On 10.04.13 at 02:43, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> OK, thinking about the GDT here.
>> 
>> The GDT is quite small -- 256 bytes on i386, 128 bytes on x86-64.  As
>> such, we probably don't want to allocate a full page to it for only
>> that.  This means that in order to create a readonly mapping we have
>to
>> pack GDTs from different CPUs together in the same pages, *or* we
>> tolerate that other things on the same page gets reflected in the
>same
>> mapping.
>
>I think a read-only GDT is incompatible with exceptions delivered
>through task gates (i.e. double fault on 32-bit), so I would assume
>this needs to remain a 64-bit only thing.
>
>> However, the packing solution has the advantage of reducing address
>> space consumption which matters on 32 bits: even on i386 we can
>easily
>> burn a megabyte of address space for 4096 processors, but burning 16
>> megabytes starts to hurt.
>
>Packing would have the additional benefit of Xen not needing to
>become a special case in yet another area (because pages
>containing live descriptor table entries need to be read-only for
>PV guests, and need to consist of only descriptor table entries).
>
>Jan

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
