MIME-Version: 1.0
In-Reply-To: <1WzwohmrS5BCBWVRHghDWZLcRvSX1dfUVqv_EAukcB1RdMdq-KUG6jjVFSQVaR1iWKToJORgS7yUXKg6JhR_n0zRILrxvKqoIIOwKbC_b_8=@protonmail.com>
References: <s-RLZ9Rez7ayjezQ5oIB5j2qnFqI2e7U7CQf9iGc882wCJB0ZBY7O3xqUyjgqkt3tIthstuRtaPsV_iombyZBru2qIZyjWPyDP7Xj7j9_cQ=@protonmail.com>
 <20170717150110.GA32089@kroah.com> <1WzwohmrS5BCBWVRHghDWZLcRvSX1dfUVqv_EAukcB1RdMdq-KUG6jjVFSQVaR1iWKToJORgS7yUXKg6JhR_n0zRILrxvKqoIIOwKbC_b_8=@protonmail.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Tue, 18 Jul 2017 13:20:18 +0200
Message-ID: <CA+rthh8rBse+W_n80y2V48pK-LsiwSZj-Ysq1=RrTA4jyWwo7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re : Re: Compilation error and probable exploit
To: Cleric John Preston <Cleric.John.Preston@protonmail.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 18 July 2017 at 08:46, Cleric John Preston
<Cleric.John.Preston@protonmail.com> wrote:
>> On Mon, Jul 17, 2017 at 10:26:53AM -0400, Cleric John Preston wrote:
>>> In compiling linux 4.9.38 I have a lot of error ...
>>> I do not think anything is wanted.
>>
>> Are you using gcc-7? Was this different from 4.9.37?
>
> No I use gcc-5.3.1 and because this is the latest unofficial version of
> grsec that I can use. See
> https://github.com/minipli/linux-unofficial_grsec/releases

In this case you should complain at [1] instead, not here, as your
problem (which one, btw?) is not related to the upstream kernel
v4.9.38 but a heavily patched one.

Cheers,
Mathias

[1] https://github.com/minipli/linux-unofficial_grsec/issues
