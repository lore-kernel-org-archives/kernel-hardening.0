Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <m2ipooe67r.fsf@firstfloor.org>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com> <20110630075716.GB3377@albatros>
 <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com> <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
 <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com> <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
 <m2ipooe67r.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2011 11:32:24 -0700
Message-ID: <CA+55aFymwBJ9CxOpnjnNxOxncHLkwfeFQ4Mm=ZhWBZDEAfAd1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Andi Kleen <andi@firstfloor.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 11:29 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>
>> =A0#define KB 1024
>
> Needs to be 1024ULL, because the counters are 64bit.
>
>> =A0#define MB (1024*KB)
>> +#define KB_MASK (~(KB-1))
>
> Otherwise you lose the upper 32bits here.

No, it's an "int" constant, so it will sign-extend properly when it
gets extended to 64 bits.

It's "unsigned int" etc that can be dangerous in these kinds of situations.

(Of course, in other contexts, sign-extensions of masks is *bad*. So
it depends on what you do)

                     Linus
