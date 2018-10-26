Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
From: Markus Heiser <markus.heiser@darmarit.de>
Message-ID: <094556ca-ea87-9c4a-2115-600d2833fb2a@darmarit.de>
Date: Fri, 26 Oct 2018 13:09:08 +0200
MIME-Version: 1.0
In-Reply-To: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Am 26.10.18 um 11:26 schrieb Peter Zijlstra:
 >> Jon,
 >>
 >> So the below document is a prime example for why I think RST sucks. As a
 >> text document readability is greatly diminished by all the markup
 >> nonsense.
 >>
 >> This stuff should not become write-only content like html and other
 >> gunk. The actual text file is still the primary means of reading this.
 >
 > I think Igor neglected to read doc-guide/sphinx.rst:
 >
 > Specific guidelines for the kernel documentation
 > ------------------------------------------------
 >
 > Here are some specific guidelines for the kernel documentation:
 >
 > * Please don't go overboard with reStructuredText markup. Keep it
 >    simple. For the most part the documentation should be plain text with
 >    just enough consistency in formatting that it can be converted to
 >    other formats.
 >
 > I agree that it's overly marked up.

To add my two cent ..

 > WTH is with all those ** ?

I guess Igor was looking for a definition list ...

 >> +Available protections for kernel data
 >> +-------------------------------------
 >> +
 >> +- **constant**
 >> +   Labelled as **const**, the data is never supposed to be altered.
 >> +   It is statically allocated - if it has any memory footprint at all.
 >> +   The compiler can even optimize it away, where possible, by replacing
 >> +   references to a **const** with its actual value.


+Available protections for kernel data
+-------------------------------------
+
+constant
+   Labelled as const, the data is never supposed to be altered.
+   It is statically allocated - if it has any memory footprint at all.
+   The compiler can even optimize it away, where possible, by replacing
+   references to a const with its actual value.

see "Lists and Quote-like blocks" [1]

[1] 
http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#lists-and-quote-like-blocks

-- Markus --
