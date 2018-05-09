From: Kees Cook <keescook@chromium.org>
Subject: [RFC][PATCH 00/13] Provide saturating helpers for allocation
Date: Tue,  8 May 2018 17:42:16 -0700
Message-Id: <20180509004229.36341-1-keescook@chromium.org>
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a stab at providing three new helpers for allocation size
calculation:

struct_size(), array_size(), and array3_size().

These are implemented on top of Rasmus's overflow checking functions,
and the last 8 patches are all treewide conversions of open-coded
multiplications into the various combinations of the helper functions.

-Kees
