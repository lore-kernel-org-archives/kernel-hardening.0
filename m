Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 12:56:12 -0500 (EST)
Message-Id: <20161214.125612.1361254098267633173.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9pEM=cDC5S=j1BU2oCF8-WdnbRfiVojcet4rXcRLcpJRw@mail.gmail.com>
References: <20161214035927.30004-1-Jason@zx2c4.com>
	<20161214035927.30004-3-Jason@zx2c4.com>
	<CAHmME9pEM=cDC5S=j1BU2oCF8-WdnbRfiVojcet4rXcRLcpJRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 3/4] secure_seq: use siphash24 instead of
 md5_transform
To: Jason@zx2c4.com
Cc: David.Laight@aculab.com, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, ak@linux.intel.com, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 14 Dec 2016 13:53:10 +0100

> In all current uses of __packed in the code, I think the impact is
> precisely zero, because all structures have members in descending
> order of size, with each member being a perfect multiple of the one
> below it. The __packed is therefore just there for safety, in case
> somebody comes in and screws everything up by sticking a u8 in
> between.

Just marking the structure __packed, whether necessary or not, makes
the compiler assume that the members are not aligned and causes
byte-by-byte accesses to be performed for words.

Never, _ever_, use __packed unless absolutely necessary, it pessimizes
the code on cpus that require proper alignment of types.
