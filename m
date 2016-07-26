Reply-To: kernel-hardening@lists.openwall.com
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
 <20160726200309.GJ4541@io.lakedaemon.net>
 <476DC76E7D1DF2438D32BFADF679FC560125F29C@ORSMSX103.amr.corp.intel.com>
 <20160726205944.GM4541@io.lakedaemon.net>
 <476DC76E7D1DF2438D32BFADF679FC5601260068@ORSMSX103.amr.corp.intel.com>
 <20160726214453.GN4541@io.lakedaemon.net>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <5797F78A.2000600@intel.com>
Date: Tue, 26 Jul 2016 16:51:38 -0700
MIME-Version: 1.0
In-Reply-To: <20160726214453.GN4541@io.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: Jason Cooper <jason@lakedaemon.net>, "Roberts, William C" <william.c.roberts@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "nnk@google.com" <nnk@google.com>, "jeffv@google.com" <jeffv@google.com>, "salyzyn@android.com" <salyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/26/2016 02:44 PM, Jason Cooper wrote:
>> > I'd likely need to take a small sample of programs and examine them,
>> > especially considering That as gaps are harder to find, it forces the
>> > randomization down and randomization can Be directly altered with
>> > length on mmap(), versus randomize_addr() which didn't have this
>> > restriction but OOM'd do to fragmented easier.
> Right, after the Android feedback from Nick, I think you have a lot of
> work on your hands.  Not just in design, but also in developing convincing
> arguments derived from real use cases.

Why not just have the feature be disabled on 32-bit by default?  All of
the Android problems seemed to originate with having a constrained
32-bit address space.
