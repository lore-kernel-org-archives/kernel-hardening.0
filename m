Date: Tue, 28 Feb 2017 16:06:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170228160607.183a88bd491e97fa6a7ded9c@linux-foundation.org>
In-Reply-To: <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
References: <476DC76E7D1DF2438D32BFADF679FC562307BAE6@ORSMSX103.amr.corp.intel.com>
	<163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: Add ability to find bad uses of vsprintf
 %p<foo> extensions
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, "Roberts, William C" <william.c.roberts@intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 27 Feb 2017 12:54:55 -0800 Joe Perches <joe@perches.com> wrote:

> %pK was at least once misused at %pk in an out-of-tree module.
> This lead to some security concerns.  Add the ability to track
> single and multiple line statements for misuses of %p<foo>.

Should we also do this?

--- a/lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix
+++ a/lib/vsprintf.c
@@ -1477,6 +1477,9 @@ int kptr_restrict __read_mostly;
  * by an extra set of alphanumeric characters that are extended format
  * specifiers.
  *
+ * Please update scripts/checkpatch.pl when adding new conversion characters.
+ * (search for "check for vsprintf extension").
+ *
  * Right now we handle:
  *
  * - 'F' For symbolic function descriptor pointers with offset
_
