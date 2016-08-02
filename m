Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC5601276FB4@ORSMSX103.amr.corp.intel.com>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
 <20160726200309.GJ4541@io.lakedaemon.net> <476DC76E7D1DF2438D32BFADF679FC560125F29C@ORSMSX103.amr.corp.intel.com>
 <20160726205944.GM4541@io.lakedaemon.net> <CAFJ0LnEZW7Y1zfN8v0_ckXQZn1n-UKEhf_tSmNOgHwrrnNnuMg@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC5601276FB4@ORSMSX103.amr.corp.intel.com>
From: Nick Kralevich <nnk@google.com>
Date: Tue, 2 Aug 2016 10:02:49 -0700
Message-ID: <CAFJ0LnF7GGCk0LaJXQtBP9sROM3S3+d6hJ=1SjjgwpBcfGqJ1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jeffv@google.com" <jeffv@google.com>, "salyzyn@android.com" <salyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 9:57 AM, Roberts, William C
<william.c.roberts@intel.com> wrote:
> @nnk, disabling ASLR via set_arch() on Android, is that only for 32 bit address spaces where
> you had that problem?

Yes. Only 32 bit address spaces had the fragmentation problem.

-- 
Nick Kralevich | Android Security | nnk@google.com | 650.214.4037
