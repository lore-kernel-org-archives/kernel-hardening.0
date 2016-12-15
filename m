Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB02401A1@AcuExch.aculab.com>
References: <20161214035927.30004-1-Jason@zx2c4.com> <20161214184605.24006-1-Jason@zx2c4.com>
 <20161214184605.24006-3-Jason@zx2c4.com> <063D6719AE5E284EB5DD2968C1650D6DB02401A1@AcuExch.aculab.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 15 Dec 2016 19:51:13 +0100
Message-ID: <CAHmME9owmJEuVTiyjMGi5FutCUHMaA9o2MfY+dtCPMBi8tgkCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 3/3] random: use siphash24 instead of md5 for get_random_int/long
To: David Laight <David.Laight@aculab.com>
Cc: Netdev <netdev@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, Ted Tso <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

On Thu, Dec 15, 2016 at 11:14 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Behalf Of Jason A. Donenfeld
>> Sent: 14 December 2016 18:46
> ...
>> +     ret = *chaining = siphash24((u8 *)&combined, offsetof(typeof(combined), end),
>
> If you make the first argument 'const void *' you won't need the cast
> on every call.
>
> I'd also suggest making the key u64[2].

I'll do both. Thanks for the suggestion.

Jason
