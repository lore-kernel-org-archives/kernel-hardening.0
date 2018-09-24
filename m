Subject: Re: temporal and spatial locality in the kernel
References: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
 <CAGXu5jKPeXWVV0480xt_5K4O2x8iA2xRf_9t8Rr0yG6szYebhQ@mail.gmail.com>
 <CALS6=qWNeRM18kgtvpVZw2O6+Zt5eJdOQ2cXbDCbEkBCeRSe4A@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <c58828e1-2196-71b5-9b87-d2c31c7ccd5b@redhat.com>
Date: Mon, 24 Sep 2018 00:42:40 -0700
MIME-Version: 1.0
In-Reply-To: <CALS6=qWNeRM18kgtvpVZw2O6+Zt5eJdOQ2cXbDCbEkBCeRSe4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Carter Cheng <cartercheng@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 09/23/2018 01:39 AM, Carter Cheng wrote:
> I suspect any modification would have to be made on the compilerside as some sort of compiler plugin since skimming over the papers
in the area most optimize by doing some sort of dataflow analysis
(removing runtime checks when not needed). To produce something like
this would require reading through some of the literature and open
source and constructing the compiler transform pass in gcc or clang.
Is gcc currently preferred for something like this?

gcc is still the "official" compiler but LLVM support has come a
long way. I'd recommend starting with a gcc plugin since that's
what we have the most support for. If you want to do work to
add LLVM plugins, that would be great too.

Thanks,
Laura
